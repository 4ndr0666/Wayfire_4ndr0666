#!/bin/python3
"""
Wayfire Socket

Provides a class WayfireSocket implementing a JSON-based protocol over
a UNIX domain socket.
"""
import os
import socket
import json

DEFAULT_SOCKET_PATH = "/tmp/wayfire-ipc.sock"

class WayfireSocket:
    def __init__(self, socket_path=DEFAULT_SOCKET_PATH, timeout=5):
        self.socket_path = socket_path
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.settimeout(timeout)
        try:
            self.sock.connect(self.socket_path)
        except socket.error as e:
            raise RuntimeError(f"Failed to connect to Wayfire IPC socket {socket_path}: {e}")
        self._read_buffer = b""

    def _readline(self):
        while b"\n" not in self._read_buffer:
            chunk = self.sock.recv(1024)
            if not chunk:
                raise RuntimeError("Connection closed by Wayfire IPC server")
            self._read_buffer += chunk
        line, self._read_buffer = self._read_buffer.split(b"\n", 1)
        return line.decode("utf-8")

    def read_next_event(self):
        line = self._readline()
        return json.loads(line)

    def send_command(self, command, **kwargs):
        msg = {"command": command}
        msg.update(kwargs)
        payload = json.dumps(msg) + "\n"
        total_sent = 0
        while total_sent < len(payload):
            sent = self.sock.send(payload[total_sent:].encode("utf-8"))
            if sent == 0:
                raise RuntimeError("Socket connection broken")
            total_sent += sent
        if command != "watch":
            return self._read_response()
        return None

    def _read_response(self):
        line = self._readline()
        return json.loads(line)

    def watch(self, events):
        return self.send_command("watch", events=events)

    def get_output(self, output_id):
        return self.send_command("get_output", output_id=output_id)

    def get_tiling_layout(self, wset, wsx, wsy):
        return self.send_command("get_tiling_layout", wset=wset, wsx=wsx, wsy=wsy)

    def set_tiling_layout(self, wset, wsx, wsy, layout):
        return self.send_command("set_tiling_layout", wset=wset, wsx=wsx, wsy=wsy, layout=layout)

    def close(self):
        try:
            self.sock.shutdown(socket.SHUT_RDWR)
        except:
            pass
        self.sock.close()

if __name__ == "__main__":
    try:
        wf_sock = WayfireSocket()
        print("Connected to Wayfire IPC socket.")
        wf_sock.watch(["view-mapped"])
        event = wf_sock.read_next_event()
        print("Got event:", event)
    except Exception as e:
        print("Error:", e)

#!/usr/bin/python

import json
import requests


def _url(path):
    return 'http://192.168.100.8:5000/' + path


class UserFlow(object):
    token = ""
    user_id = ""

    def on_start(self):
        self.login()
        self.get_users()

    def login(self):
        data = {"email": "gauravdabhade24@gmail.com", "password": "password"}
        resp = requests.post(_url("auth/login"), json=data,
                             headers={"Content-Type": "application/json", "Accept": "application/json"})
        self.token = resp.json()["auth_token"]

    def get_users(self):
        resp = requests.get(_url("auth/status"),
                            headers={"Authorization": "bearer " + self.token, "Content-Type": "application/json",
                                     "Accept": "application/json"})
        self.user_id = resp.json()["data"]["user_id"]
        print(json.dumps(self.__dict__))


if __name__ == '__main__':
    task_set = UserFlow()
    task_set.on_start()

<?php

class PasswordToken extends BaseObject implements DatedObject {

  static function create($userId) {
    $pt = Model::factory('PasswordToken')->create();
    $pt->userId = $userId;
    $pt->token = Str::randomString(30);
    $pt->save();
    return $pt;
  }

}
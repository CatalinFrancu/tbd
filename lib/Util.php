<?php

class Util {

  static function assertNotLoggedIn() {
    if (User::getActive()) {
      Util::redirectToHome();
    }
  }

  static function redirect($location, $statusCode = 303) {
    FlashMessage::saveToSession();
    header("Location: $location", true, $statusCode);
    exit;
  }

  static function redirectToRoute($route) {
    self::redirect(Router::link($route));
  }

  static function redirectToHome() {
    self::redirect(Config::URL_PREFIX);
  }

  // Redirects to the same page, stripping any GET parameters but preserving
  // any slash-delimited arguments.
  static function redirectToSelf() {
    $uri = $_SERVER['REQUEST_URI'];
    $path = parse_url($uri, PHP_URL_PATH);
    self::redirect($path);
  }

}

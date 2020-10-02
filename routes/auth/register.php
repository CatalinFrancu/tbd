<?php

Util::assertNotLoggedIn();

// there may or may not be an invite code
$code = Request::get('code');

if (!$code && !Config::ALLOW_REGISTRATION) {
  FlashMessage::add(_('info-registration-disabled'));
  Util::redirectToHome();
} else if ($code && !Config::ALLOW_INVITES) {
  FlashMessage::add(_('info-invites-disabled'));
  Util::redirectToHome();
}

if ($code) {
  $invite = Invite::get_by_code($code);
  if (!$invite) {
    FlashMessage::add(_('info-incorrect-invite-code'));
    Util::redirectToHome();
  } else if ($invite->receiverId) {
    FlashMessage::add(_('info-invite-already-accepted'));
    Util::redirectToHome();
  }
} else {
  $invite = null;
}

$nickname = Request::get('nickname');
$email = Request::get('email');
$password = Request::get('password');
$password2 = Request::get('password2');
$remember = Request::has('remember');
$submitButton = Request::has('submitButton');

if ($submitButton) {
  $errors = validate($nickname, $email, $password, $password2);

  if ($errors) {
    Smart::assign(['errors' => $errors]);
  } else {

    $user = Model::factory('User')->create();
    $user->nickname = $nickname;
    $user->email = $email;
    $user->password = md5($password);
    $user->save();
    $user->setReputation(0);

    // invalidate this invite
    if ($invite) {
      $invite->acceptedBy($user);
    }

    // invalidate any other outstanding invite for this email
    Invite::acceptByEmail($user);

    Session::login($user, $remember);
  }
}

Smart::assign([
  'nickname' => $nickname,
  'email' => $email,
  'password' => $password,
  'password2' => $password2,
  'remember' => $remember,
]);
Smart::display('auth/register.tpl');

/*************************************************************************/

function validate($nickname, $email, $password, $password2) {
  $errors = [];

  $msg = User::canChooseNickname($nickname);
  if ($msg) {
    $errors['nickname'][] = $msg;
  }

  $msg = User::canChooseEmail($email);
  if ($msg) {
    $errors['email'][] = $msg;
  }

  $msg = User::validateNewPassword($password, $password2);
  if ($msg) {
    $errors['password'][] = $msg;
  }

  return $errors;
}

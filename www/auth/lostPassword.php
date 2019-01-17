<?php

require_once '../../lib/Core.php';
Util::assertNotLoggedIn();

$email = Request::get('email');
$submitButton = Request::has('submitButton');

Smart::assign(['email' => $email]);

if ($submitButton) {
  $errors = validate($email);

  if ($errors) {
    Smart::assign(['errors' => $errors]);
  } else {

    $user = User::get_by_email($email);
    if ($user) {
      Log::notice("Password recovery requested for $email from " . $_SERVER['REMOTE_ADDR']);

      $pt = PasswordToken::create($user->id);

      // Send email
      Smart::assign([
        'homePage' => Request::getFullServerUrl(),
        'token' => $pt->token,
      ]);
      $from = Config::CONTACT_EMAIL;
      $subject = 'Schimbarea parolei pentru tbd';
      $body = Smart::fetch('email/lostPassword.tpl');

      Mailer::setRealMode();
      Mailer::send($from, [$email], $subject, $body);
    }

    // Display a confirmation even for incorrect addresses.
    Smart::display('auth/lostPasswordEmailSent.tpl');
    exit;
  }
}

Smart::display('auth/lostPassword.tpl');

/*************************************************************************/

function validate($email) {
  $errors = [];

  if (!$email) {
    $errors['email'] = _('Please enter an email address.');
  } else if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errors['email'] = _('This email address looks incorrect.');
  }

  return $errors;
}

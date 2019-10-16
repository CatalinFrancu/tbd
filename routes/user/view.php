<?php

$id = Request::get('id');
$nickname = Request::get('nickname');

$user = User::get_by_id_nickname($id, $nickname);

if (!$user) {
  FlashMessage::add(_('The user you are looking for does not exist.'));
  Util::redirectToHome();
}

$statements = Statement::count_by_userId($user->id);
$answers = Answer::count_by_userId($user->id);

Smart::assign([
  'user' => $user,
  'answers' => $answers,
  'statements' => $statements,
]);
Smart::display('user/view.tpl');

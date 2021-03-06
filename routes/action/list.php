<?php

/**
 * Display page #p (1-based) of the user's action log as JSON.
 *
 * For illegal operations, we return an error code of 404 and print the
 * JSON-encoded error message.
 **/

$userId = Request::get('userId');
$p = Request::get('page');

header('Content-Type: application/json');

try {

  $u = User::get_by_id($userId);
  if (!$u) {
    throw new Exception(_('info-no-such-user'));
  }

  $actions = $u->getActionPage($p);

  Smart::assign('actions', $actions);
  $html = Smart::fetch('bits/actions.tpl');
  $response = [
    'html' => $html,
  ];
  print json_encode($response);

} catch (Exception $e) {

  http_response_code(404);
  print json_encode($e->getMessage());

}

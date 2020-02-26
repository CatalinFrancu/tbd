<?php

class Answer extends Proto {
  use FlaggableTrait, MarkdownTrait, PendingEditTrait, VerdictTrait, VotableTrait;

  function getObjectType() {
    return self::TYPE_ANSWER;
  }

  function getMarkdownFields() {
    return [ 'contents' ];
  }

  function getUser() {
    return User::get_by_id($this->userId);
  }

  function getStatement() {
    return Statement::get_by_id($this->statementId);
  }

  function getScore() {
    return AnswerExt::getField($this->id, 'score');
  }

  function setScore($score) {
    return AnswerExt::setField($this->id, 'score', $score);
  }

  /**
   * Returns a human-readable message if this Answer is deleted or null
   * otherwise.
   *
   * @return string
   */
  function getDeletedMessage() {
    if ($this->status != Ct::STATUS_DELETED) {
      return null;
    }

    $msg = _('info-answer-deleted');

    switch ($this->reason) {
      case Ct::REASON_SPAM: $r = _('info-answer-spam'); break;
      case Ct::REASON_ABUSE: $r = _('info-answer-abuse'); break;
      case Ct::REASON_OFF_TOPIC: $r = _('info-answer-off-topic'); break;
      case Ct::REASON_LOW_QUALITY: $r = _('info-answer-low-quality'); break;
      case Ct::REASON_BY_OWNER: $r = _('info-answer-by-owner'); break;
      case Ct::REASON_BY_USER: $r = _('info-by'); break;
      case Ct::REASON_OTHER: $r = _('info-other-reason'); break;
      default: $r = '';
    }

    return $msg . ' ' . $r;
  }

  /**
   * Create a blank answer assigned to a statement.
   *
   * @param int $statementId
   * @return Answer
   */
  static function create($statementId) {
    $a = Model::factory('Answer')->create();
    $a->statementId = $statementId;
    return $a;
  }

  function sanitize() {
    $this->contents = trim($this->contents);
  }

  function isViewable() {
    return
      ($this->status != Ct::STATUS_PENDING_EDIT) &&
      (($this->status != Ct::STATUS_DELETED) ||
       User::may(User::PRIV_DELETE_ANSWER));
  }

  protected function isEditableCore() {
    if (!$this->id && !User::may(User::PRIV_ADD_ANSWER)) {
      throw new Exception(sprintf(
        _('info-minimum-reputation-add-answer-%s'),
        Str::formatNumber(User::PRIV_ADD_ANSWER)));
    }

    if ($this->id &&
        !User::may(User::PRIV_EDIT_ANSWER) &&     // can edit any answers
        $this->userId != User::getActiveId()) {   // can always edit user's own answers
      throw new Exception(sprintf(
        _('info-minimum-reputation-edit-answer-%s'),
        Str::formatNumber(User::PRIV_EDIT_ANSWER)));
    }

    if ($this->proof &&
        !User::isModerator()) {
      throw new Exception(_('info-only-moderator-edit-proof-answer'));
    }
  }

  /**
   * Checks whether the active user may delete this answer.
   *
   * @return boolean
   */
  function isDeletable() {
    // TODO: not deletable if accepted
    return
      $this->status == Ct::STATUS_ACTIVE &&
      (User::may(User::PRIV_DELETE_ANSWER) ||    // can delete any answer
       $this->userId == User::getActiveId());    // can always delete user's own answers
  }

  function close($reason) {
    throw new Exception('Answers should never be closed.');
  }

  function closeAsDuplicate($duplicateId) {
    throw new Exception('Answers should never be closed as a duplicate.');
  }

  protected function deepMerge($other) {
    $this->copyFrom($other);
    $this->save($other->modUserId);
  }

  function delete() {
    if ($this->status != Ct::STATUS_PENDING_EDIT) {
      throw new Exception('Answers should never be deleted at the DB level.');
    }

    AttachmentReference::deleteObject($this);
    // a pending edit answer should not have reviews, tags or votes

    AnswerExt::delete_all_by_answerId($this->id);

    parent::delete();
  }
}

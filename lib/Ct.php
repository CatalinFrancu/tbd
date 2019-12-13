<?php

/**
 * Container for constants that apply to multiple classes and don't belong to
 * any one class.
 */

class Ct {

  // Applicable to FlaggableTrait objects (which can therefore be closed or
  // deleted). PHP won't let us define constants in traits
  const STATUS_ACTIVE = 0;
  const STATUS_CLOSED = 1;
  const STATUS_DELETED = 2;
  const STATUS_PENDING_EDIT = 3;

  // Reasons for starting a review and for closing and deleting objects.
  const REASON_SPAM = 1;
  const REASON_ABUSE = 2;
  const REASON_DUPLICATE = 3;
  const REASON_OFF_TOPIC = 4;
  const REASON_UNVERIFIABLE = 5;
  const REASON_LOW_QUALITY = 6;
  const REASON_NEW_USER = 7;
  const REASON_LATE_ANSWER = 8;
  const REASON_BY_OWNER = 9;
  const REASON_BY_USER = 10;
  const REASON_REOPEN = 11;
  const REASON_OTHER = 12;
  const NUM_REASONS = 12;

  const ONE_DAY_IN_SECONDS = 24 * 3600;

}
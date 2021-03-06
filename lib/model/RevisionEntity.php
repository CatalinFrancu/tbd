<?php

class RevisionEntity extends Entity {
  use RevisionTrait;

  /**
   * @param $prev The previous revision of the same entity.
   * @return ObjectDiff
   */
  function compare($prev) {
    $od = new ObjectDiff($this);

    // object fields
    $this->diffField(_('title-changes-profile'), $prev->profile, $this->profile, $od);

    $this->compareField(_('label-entity-name'),
                        $prev->name,
                        $this->name,
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->compareField(_('phrase-short-possessive'),
                        $prev->shortPossessive,
                        $this->shortPossessive,
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->compareField(_('phrase-long-possessive'),
                        $prev->longPossessive,
                        $this->longPossessive,
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->compareField(_('label-entity-type'),
                        $prev->getEntityType()->name,
                        $this->getEntityType()->name,
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->compareField(_('label-entity-color'),
                        $prev->getColor(),
                        $this->getColor(),
                        $od, Ct::FIELD_CHANGE_COLOR);
    $this->compareField(_('label-region'),
                        $prev->getRegion()->name ?? '',
                        $this->getRegion()->name ?? '',
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->compareField(_('label-status'),
                        $prev->getStatusName(),
                        $this->getStatusName(),
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->compareField(_('label-image-file'),
                        $prev->fileExtension,
                        $this->fileExtension,
                        $od, Ct::FIELD_CHANGE_STRING);
    $this->addDuplicateInfo($prev->duplicateId,
                            $this->duplicateId,
                            $od, $this->getDuplicate());

    // added / removed tags
    $tags = RevisionObjectTag::getChangesFor($this, 'insert');
    $this->compareField(_('label-added-tags'),
                        $tags,
                        [],
                        $od, Ct::FIELD_CHANGE_TAG_LIST);

    $tags = RevisionObjectTag::getChangesFor($this, 'delete');
    $this->compareField(_('label-deleted-tags'),
                        $tags,
                        [],
                        $od, Ct::FIELD_CHANGE_TAG_LIST);

    // added / removed / edited aliases
    $aliases = RevisionAlias::getChangesFor($this, 'insert');
    $this->compareField(_('label-added-aliases'),
                        $aliases,
                        [],
                        $od, Ct::FIELD_CHANGE_STRING_LIST);

    $aliases = RevisionAlias::getChangesFor($this, 'delete');
    $this->compareField(_('label-deleted-aliases'),
                        $aliases,
                        [],
                        $od, Ct::FIELD_CHANGE_STRING_LIST);

    $aliases = RevisionAlias::getChangesFor($this, 'update');
    foreach ($aliases as $a) {
      $prevAlias = $a->getPreviousRevision();
      $this->compareField(_('label-changed-alias'),
                          (string)$prevAlias,
                          (string)$a,
                          $od, Ct::FIELD_CHANGE_STRING);
    }

    // added / removed / edited links
    $links = RevisionLink::getChangesFor($this, 'insert');
    $this->compareField(_('label-added-entity-links'),
                        $links,
                        [],
                        $od, Ct::FIELD_CHANGE_LINK_LIST);

    $links = RevisionLink::getChangesFor($this, 'delete');
    $this->compareField(_('label-deleted-entity-links'),
                        $links,
                        [],
                        $od, Ct::FIELD_CHANGE_LINK_LIST);

    $links = RevisionLink::getChangesFor($this, 'update');
    foreach ($links as $l) {
      $prevL = $l->getPreviousRevision();
      $this->compareField(_('label-changed-entity-link'),
                          (string)$prevL,
                          (string)$l,
                          $od, Ct::FIELD_CHANGE_LINK);
    }

    // added / removed / edited relations
    $relations = RevisionRelation::getChangesFor($this, 'insert');
    $this->compareField(_('label-added-relations'),
                        $relations,
                        [],
                        $od, Ct::FIELD_CHANGE_RELATION_LIST);

    $relations = RevisionRelation::getChangesFor($this, 'delete');
    $this->compareField(_('label-deleted-relations'),
                        $relations,
                        [],
                        $od, Ct::FIELD_CHANGE_RELATION_LIST);

    $relations = RevisionRelation::getChangesFor($this, 'update');
    foreach ($relations as $r) {
      $prevR = $r->getPreviousRevision();
      $this->compareField(_('label-changed-relation'),
                          (string)$prevR,
                          (string)$r,
                          $od, Ct::FIELD_CHANGE_STRING);
    }

    $od->checkReview($this);

    return $od;
  }
}

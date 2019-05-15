<?php

// Utilities for objects that have images

class Img {

  private static function getSubdirectory($obj) {
    return strtolower(get_class($obj));
  }

  private static function getImageLocation($obj) {
    if (!$obj->imageExtension || !$obj->id) {
      return '';
    }

    $subdir = self::getSubdirectory($obj);
    $path = sprintf('%simg/%s/%d.%s',
                    Config::SHARED_DRIVE, $subdir, $obj->id, $obj->imageExtension);
    return $path;
  }

  // assumes $thumbIndex is a valid index in Config::THUMB_SIZES
  private static function getThumbLocation($obj, $thumbIndex) {
    if (!$obj->imageExtension || !$obj->id) {
      return '';
    }

    $rec = Config::THUMB_SIZES[$thumbIndex];
    $subdir = self::getSubdirectory($obj);
    $path = sprintf('%simg/%s/thumb-%dx%d/%d.%s',
                    Config::SHARED_DRIVE,
                    $subdir,
                    $rec[0],
                    $rec[1],
                    $obj->id,
                    $obj->imageExtension);
    return $path;
  }

  static function getThumbLink($obj, $thumbIndex) {
    $subdir = self::getSubdirectory($obj);
    return sprintf('%s/%d/%d.%s',
                   Router::link("{$subdir}/image"),
                   $obj->id,
                   $thumbIndex,
                   $obj->imageExtension);
  }

  /**
   * If the thumbnail exists, returns its dimensions. If not, falls back to
   * the Config.php values. The two may differ due to differences in aspect.
   **/
  static function getThumbSize($obj, $thumbIndex) {
    $file = self::getThumbLocation($obj, $thumbIndex);

    $rec = ($file && file_exists($file))
      ? getimagesize($file)
      : Config::THUMB_SIZES[$thumbIndex];

    return [
      'width' => $rec[0],
      'height' => $rec[1],
    ];
  }

  // delete all image and thumbnail files
  static function deleteImages($obj) {
    $subdir = self::getSubdirectory($obj);
    $cmd = sprintf('rm -f %simg/%s/%d.* %simg/%s/thumb-*/%d.*',
                   Config::SHARED_DRIVE, $subdir, $obj->id,
                   Config::SHARED_DRIVE, $subdir, $obj->id);
    OS::execute($cmd, $ignored);
  }

  static function copyUploadedImage($obj, $tmpImageName) {
    self::deleteImages($obj);

    $dest = self::getImageLocation($obj);
    @mkdir(dirname($dest), 0777, true);
    copy($tmpImageName, $dest);
  }

  static function renderThumb($class, $id, $fileName) {

    @list($thumb, $extension) = explode('.', $fileName, 2);

    $obj = $class::get_by_id($id);

    if (!$obj ||
        !$obj->imageExtension ||
        ($obj->imageExtension != $extension) ||
        !isset(Config::THUMB_SIZES[$thumb])) {
      http_response_code(404);
      exit;
    }

    // generate the thumb unless it already exists
    $imgLocation =  self::getImageLocation($obj);
    $thumbLocation = self::getThumbLocation($obj, $thumb);
    if (!file_exists($thumbLocation)) {
      list($width, $height) = Config::THUMB_SIZES[$thumb];
      @mkdir(dirname($thumbLocation), 0777, true);
      $cmd = sprintf('convert -geometry %dx%d -sharpen 1x1 %s %s',
                     $width, $height, $imgLocation, $thumbLocation);
      OS::execute($cmd, $ignored);
    }

    // now dump it

    if (file_exists($thumbLocation)) {

      $mimeType = array_search($extension, Config::IMAGE_MIME_TYPES);
      header('Content-Type:' . $mimeType);
      header('Content-Length: ' . filesize($thumbLocation));
      readfile($thumbLocation);

    } else {
      http_response_code(404);
    }
  }
}

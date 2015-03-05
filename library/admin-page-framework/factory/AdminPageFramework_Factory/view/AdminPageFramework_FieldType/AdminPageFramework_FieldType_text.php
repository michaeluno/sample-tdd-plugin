<?php
/**
 Admin Page Framework v3.5.5b01 by Michael Uno
 Generated by PHP Class Files Script Generator <https://github.com/michaeluno/PHP-Class-Files-Script-Generator>
 <http://en.michaeluno.jp/admin-page-framework>
 Copyright (c) 2013-2015, Michael Uno; Licensed under MIT <http://opensource.org/licenses/MIT>
 */
class SampleTDDPlugin_AdminPageFramework_FieldType_text extends SampleTDDPlugin_AdminPageFramework_FieldType {
    public $aFieldTypeSlugs = array('text', 'password', 'date', 'datetime', 'datetime-local', 'email', 'month', 'search', 'tel', 'url', 'week',);
    protected $aDefaultKeys = array('attributes' => array('maxlength' => 400,),);
    protected function getStyles() {
        return <<<CSSRULES
/* Text Field Type */
.admin-page-framework-field-text .admin-page-framework-field .admin-page-framework-input-label-container {
    vertical-align: top; 
}
CSSRULES;
        
    }
    protected function getField($aField) {
        return $aField['before_label'] . "<div class='admin-page-framework-input-label-container'>" . "<label for='{$aField['input_id']}'>" . $aField['before_input'] . ($aField['label'] && !$aField['repeatable'] ? "<span class='admin-page-framework-input-label-string' style='min-width:" . $this->sanitizeLength($aField['label_min_width']) . ";'>" . $aField['label'] . "</span>" : "") . "<input " . $this->generateAttributes($aField['attributes']) . " />" . $aField['after_input'] . "<div class='repeatable-field-buttons'></div>" . "</label>" . "</div>" . $aField['after_label'];
    }
}
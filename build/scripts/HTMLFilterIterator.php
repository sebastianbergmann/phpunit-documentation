<?php
class HTMLFilterIterator extends FilterIterator
{
    public function accept()
    {
        return substr($this->getInnerIterator()->current(), -5) == '.html';
    }
}


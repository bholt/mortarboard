#!/usr/bin/env python
"""
Pandoc filter to convert all level 2+ headers to paragraphs with
emphasized text.
"""

from pandocfilters import *

def autoref(key, value, format, meta):
  if key == 'NumRef':
    return {'t': 'RawInline', 'c': ["tex", '\\autoref{%s}'%(value[0]['numRefId'])]}

if __name__ == "__main__":
  toJSONFilter(autoref)

_ = window._ = window._ || {}


# @param {selector} [string jquery selector]
# @throws {Error} [if element does not exists]
# @return {jquery element}
_.getElement = (selector) ->
  if $(selector).length == 0
    throw new Error "Element not found #{ selector }"
  $(selector)

# @param {selector} [string jquery selector]
# @throws {Error} [if element is not unique]
# @return {jquery element}
_.elementIsUnique = (selector)->
  $el = @getElement selector
  if $el.length > 1
    throw new Error "element is not unique #{ selector }"
  $el

_.merge = (o1, o2) ->
  $.extend o1, o2

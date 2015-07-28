ÇLootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

class CheckoutValidator

  constructor: (@form = [], callbacks = {}) ->
    @callbacks = _.merge {
      success: ->
      error: ->
      beforeEach: ->
      active: ->
      backClick: ->
    }, callbacks
    @$els = @getElements @form
    @preventSubmit()
    @setNextClick()
    @setPrevClick()
    @setUnlock()

  setUnlock: ->
    @form.find('.click-guard').on 'click', @callbacks.active
    @form.find('.form-group').on 'focusin', @callbacks.active

  preventSubmit:->
    $(@$els).filter('[type=text]').each (i, el) ->
      $(el).on 'keypress', (e) ->
        if e.keyCode == 13
          e.preventDefault()
          $(@).closest('.checkout-step').find('.btn-step').trigger('click')

  setNextClick: ->
    $btn = $(@form).find('.btn-step').not('.prev')
    $btn.on 'click', (e) =>
      e.preventDefault()
      @response()

  setPrevClick: ->
    $btn = $(@form).find('.btn-step').filter('.prev')
    $btn.on 'click', (e) =>
      e.preventDefault()
      @callbacks.backClick e

  response: ->
    @callbacks.beforeEach @form
    if @isValid()
      @callbacks.success @form
    else
      @callbacks.error @form

  isValid: (decoration = true) ->
    errors = 0
    @$els.each (i, el) =>
      if decoration
        @decorate el
      unless $.trim($(el).val())
        errors++
    errors == 0

  decorate: (el)->
    if $.trim($(el).val())
      @toogleClass $(el), 'valid', 'error'
    else
      @toogleClass $(el), 'error', 'valid'

  getElements: (form) ->
    $(form).find('input.required, select.required').not('#checkout')

  toogleClass: ($el, add, remove) ->
    $el.addClass add
    $el.removeClass remove
    $el.bind 'change', (e) ->
      $(@).removeClass add
      $el.unbind 'change'

LootCrate.pages.CheckoutValidator = CheckoutValidator

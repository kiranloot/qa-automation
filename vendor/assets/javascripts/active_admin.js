//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require autocomplete-rails
//= require active_admin/base
//= require select2


"use strict";

var lcadmin = window.lcadmin || {};

lcadmin = (function($) {

    function init() {
        initDatepicker();
        initSelect2ForInputs();
        initSelect2ForInputs.selectAllProducts();
        initSelect2ForInputs.selectCanadianProducts();
        initSelect2ForInputs.selectDomesticProducts();
        initSelect2ForInputs.selectInternationalProducts();
        initSelect2ForInputs.selectBTG();
        initAffiliateNameCase();
        generateCouponCodes();
        checkCouponPrefixAvailability();
        setMaxOnAdjustment();
        clearNewCodes();
        initValidation();
        preventCSVmultipleClick();
    }

    function initDatepicker() {
        $("#promotion_starts_at").datepicker({
          numberOfMonths: 2,
          dateFormat: "yy-mm-dd",
          onSelect: function(selected) {
            $("#promotion_ends_at").datepicker("option","minDate", selected)
          }
        });
        $("#promotion_ends_at").datepicker({
          numberOfMonths: 2,
          dateFormat: "yy-mm-dd",
          onSelect: function(selected) {
            $("#promotion_starts_at").datepicker("option","maxDate", selected)
          }
        });
    }

    function initSelect2ForInputs() {
      $('#promotion_eligible_plan_ids').select2({
        placeholder: "Select products"
      });
      $('#promotion_trigger_event').select2();

      // select all products
      function selectAllProducts() {
        $("#select_all").click(function(){
          // clear all other checkboxes
          $('.optionsProducts').prop('checked', false);
          $('.optionsFamily').prop('checked', false);

          if($("#select_all").is(':checked') ){
            $("#promotion_eligible_plan_ids option").prop("selected","selected");
            $("#promotion_eligible_plan_ids").trigger("change");
          }
          else {
            $("#promotion_eligible_plan_ids > option").removeAttr("selected");
            $("#promotion_eligible_plan_ids").trigger("change");
          }
        });
      }

      // select canadian products
      function selectCanadianProducts() {
        $('#select_canada').click(function() {
          var selected = $("#promotion_eligible_plan_ids").select2().find(":selected"),
          inval,
          stringVal = [],
          selectString = 'ca';

          if (!$("#select_all").is(':checked') && selected.length > 0) {
            selected.each(function(){
              stringVal.push($(this).val());
            });
          }

          $('.optionsProductsAll').prop('checked', false);
          if($("#select_canada").is(':checked') ){
            $('#promotion_eligible_plan_ids').find('option').each(function(){
                if($(this).is(':contains(' + selectString + ')')){
                  stringVal.push($(this).val());
                }
                $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
          else {
            $('#promotion_eligible_plan_ids').find('option').each(function(){
              inval = $(this).html().toLowerCase();
              if(inval.indexOf(selectString) == 0) {
                  stringVal.splice($.inArray($(this).val(),stringVal),1);
              }
              $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
        });
      }

      // select domestic products
      function selectDomesticProducts() {
        $('#select_domestic').click(function() {
          var selected = $("#promotion_eligible_plan_ids").select2().find(":selected"),
          inval,
          stringVal = [],
          selectArr = ['1-month', '3-month', '6-month', '12-month'];

          if (!$("#select_all").is(':checked') && selected.length > 0) {
            selected.each(function(){
              stringVal.push($(this).val());
            });
          }

          $('.optionsProductsAll').prop('checked', false);

          if($("#select_domestic").is(':checked')) {
            $('#promotion_eligible_plan_ids').find('option').each(function(){
              inval = $(this).html().toLowerCase();
              for (var i=0; i<selectArr.length; i++) {
                if(inval.indexOf(selectArr[i])==0){
                  stringVal.push($(this).val());
                }
              }
              $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
          else {
            $('#promotion_eligible_plan_ids').find('option').each(function(){
              inval = $(this).html().toLowerCase();
              for (var i=0; i<selectArr.length; i++) {
                if(inval.indexOf(selectArr[i])==0){
                  stringVal.splice($.inArray($(this).val(),stringVal),1);
                }
              }
              $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
        });
      }

      // select international products
      function selectInternationalProducts() {
        $('#select_international').click(function() {
          var selected = $("#promotion_eligible_plan_ids").select2().find(":selected"),
          inval,
          stringVal = [],
          selectArr = ['au', 'de', 'dk', 'fi', 'fr', 'gb', 'ie', 'nl', 'no', 'nz', 'se'];

          if (!$("#select_all").is(':checked') && selected.length > 0) {
            selected.each(function(){
              stringVal.push($(this).val());
            });
          }

          $('.optionsProductsAll').prop('checked', false);
          if($("#select_international").is(':checked')) {
            $('#promotion_eligible_plan_ids').find('option').each(function(){
              inval = $(this).html().toLowerCase();
              for (var i=0; i<selectArr.length; i++) {
                if(inval.indexOf(selectArr[i])==0){
                  stringVal.push($(this).val());
                }
              }
              $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
          else {
            $('#promotion_eligible_plan_ids').find('option').each(function(){
              inval = $(this).html().toLowerCase();
              for (var i=0; i<selectArr.length; i++) {
                if(inval.indexOf(selectArr[i])==0){
                  stringVal.splice($.inArray($(this).val(),stringVal),1);
                }
              }
              $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
        });
      }

      function selectBTG() {
        $('#select_btg').click(function() {
          var selected = $("#promotion_eligible_plan_ids").select2().find(":selected"),
          inval,
          stringVal = [],
          selectString = 'btg';

           if (!$("#select_all").is(':checked') && selected.length > 0) {
            selected.each(function(){
              stringVal.push($(this).val());
            });
          }

          $('.optionsProductsAll').prop('checked', false);
          if($("#select_btg").is(':checked') ){
            $('#promotion_eligible_plan_ids').find('option').each(function(){
                if($(this).is(':contains(' + selectString + ')')){
                  stringVal.push($(this).val());
                }
                $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
          else {
            $('#promotion_eligible_plan_ids').find('option').each(function(){
              inval = $(this).html().toLowerCase();
              if(inval.indexOf(selectString) == 0) {
                  stringVal.splice($.inArray($(this).val(),stringVal),1);
              }
              $('#promotion_eligible_plan_ids').val(stringVal).trigger("change");
            });
          }
        });
      }

      initSelect2ForInputs.selectAllProducts = selectAllProducts;
      initSelect2ForInputs.selectCanadianProducts = selectCanadianProducts;
      initSelect2ForInputs.selectDomesticProducts = selectDomesticProducts;
      initSelect2ForInputs.selectInternationalProducts = selectInternationalProducts;
      initSelect2ForInputs.selectBTG = selectBTG;
    }

    function initAffiliateNameCase() {
      $('#affiliate_name').on('change', function() {
        $(this).val($(this).val().toLowerCase());
      });
    }

    function checkCouponPrefixAvailability() {
        $('#promotion_coupon_prefix').on('change', function() {
          var coupon_prefix = $(this).val();

          $('#code-generation-error').text('');

          $.ajax({
            url: '/admin/promotions/check_code_availability',
            type: 'POST',
            data: {
              coupon_prefix: coupon_prefix
            }
          }).success(function(response) {
            if (response.error) {
              var errorMessage = response.error;
              $('#code-generation-error').text(errorMessage);
              $('#promotion_coupon_prefix').val('');
            }
          });
        });
    }

    // TODO: Should make this a form instead of having to do this.
    function generateCouponCodes() {
        $('#generate-coupon-codes').on('click', function() {
            var prefix     = $('#promotion_coupon_prefix').val(),
                onetimeuse_selection = $('#promotion_one_time_use', '.admin-promo-form'),
                onetimeuse_val = (onetimeuse_selection.is(':checked') || onetimeuse_selection.val() == 't'),
                charLength = !onetimeuse_val ? prefix.length : $('#char_length').val(),
                quantity   = !onetimeuse_val ? '1' : $('#quantity').val();

            $.ajax({
                url: '/admin/promotions/generate_new_codes',
                type: 'POST',
                data: {
                    prefix: prefix,
                    char_length: charLength,
                    quantity: quantity
                },
                dataType: 'json'
            }).success(function(response) {
                if (response.error) {
                    var errorMessage = response.error;
                    $('#code-generation-error').text(errorMessage);
                } else {
                    var codes = response.codes.join('\n');
                    $('#output').val(codes);
                    $('#code-generation-error').text('');
                }
            });
        });
    }

    function setMaxOnAdjustment() {
      jQuery(function($) {
        $('#promotion_adjustment_type').on('change', function() {
          if($("#promotion_adjustment_type").val().toLowerCase() == 'fixed'){
            $("#promotion_adjustment_amount").prop('max', '1000')
          }
          else if($("#promotion_adjustment_type").val().toLowerCase() == 'percentage') {
            $("#promotion_adjustment_amount").prop('max', '100')
          }
        }).trigger('change');
      });
    }

    function initValidation() {
      $("#btn-submit").click(function(event) {
        //event.preventDefault();
        if($("#promotion_trigger_event").val() == '' || $("#promotion_trigger_event").val() == null){
          $("#s2id_promotion_trigger_event").addClass('error')
        }
        else {
          $('#s2id_promotion_trigger_event').removeClass('error')
        }
      });

      $("#promotion_trigger_event").select2()
        .on("change", function(e) {
          if(e.val == '' || e.val == null){
            $("#s2id_promotion_trigger_event").addClass('error')
          }
          else{
            $('#s2id_promotion_trigger_event').removeClass('error')
          }
      });
    }

    function clearNewCodes() {
      $('#promotion_one_time_use').on('change', function(ev) {
        $('#output').val('')
      });
    }

    function preventCSVmultipleClick() {
      $('.new_orders_csv').bind('click', function(e) {
        $(this).addClass('disabled-link');
      });
    };

    return {
        init: init
    };


})(jQuery);


function promo_form_selector() {
  return '.admin-promo-form' ;
}
function multi_use_selector() {
  return '.multi-use';
}

function hide_all_multi_use() {
  return $(multi_use_selector(), promo_form_selector()).hide();
}

function show_all_multi_use() {
  return $(multi_use_selector(), promo_form_selector()).show();
}

function single_use_selector() {
  return '.single-use';
}

function hide_all_single_use() {
  return $(single_use_selector(), promo_form_selector()).hide();
}

function show_all_single_use() {
  return $(single_use_selector(), promo_form_selector()).show();
}

function onetimeuse_selector() {
  return '#promotion_one_time_use';
}

function toggle_on_selector() {
  return '.toggle-on';
}

function toggle_on() {
  $(toggle_on_selector()).show();
  $(toggle_off_selector()).hide();
}

function toggle_off_selector() {
  return '.toggle-off';
}

function toggle_off() {
  $(toggle_on_selector()).hide();
  $(toggle_off_selector()).show();
}

function toggle_selector() {
  return '.toggler';
}

function toggle_on_off() {
  var toggler = $(toggle_selector());
  if (toggler.is(':checked'))
    toggle_on();
  else
    toggle_off();
}

function toggle_onetimeuse_fields() {
  var selection = $(onetimeuse_selector(), promo_form_selector()),
      selection_val = selection.val();
  if (selection.is(':checked') || selection_val == 't') {
    show_all_single_use();
    hide_all_multi_use();
  } else {
    hide_all_single_use();
    show_all_multi_use();
  }
}

function register_onetimeuse_onchange_handler() {
  $(promo_form_selector()).on('change', onetimeuse_selector(), function(){
    toggle_onetimeuse_fields();
  });

  $(toggle_selector()).on('change', function() {
    toggle_on_off();
  });
}

$(document).ready(function() {
    lcadmin.init();
    register_onetimeuse_onchange_handler();
    toggle_onetimeuse_fields();
    toggle_on_off();
});

# ############## #
# Address
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Address = ->
  fieldName = $('#edit-container').data('fieldname')
  crateMonth = $('#edit-container').data('month')
  nextCrateMonth = $('#edit-container').data('nextmonth')
  if ($('#edit-container').data('editable') == false)
    $("#field").text(fieldName);
    $("#month").text(crateMonth);
    $("#nextmonth").text(nextCrateMonth);
    $('#shipped-alert-modal').modal({
      show: true,
      backdrop: 'static'
    })

  $('#close-alert', '.close').click ->
    $('#shipped-alert-modal').hide()
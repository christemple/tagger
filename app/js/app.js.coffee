add_tag_to_list = (selected_tag)->
  add_tag_html = "<input name=selected_tags[] data-selected-tag=#{selected_tag} value=#{selected_tag} type=hidden />"
  add_tag_html += "<div class=selected_tag data-selected-tag=#{selected_tag}>#{selected_tag}<span class=remove_selected_tag>x</span></div>"
  $('.selected_tags').append(add_tag_html)

remove_tag_from_list = (selected_tag)->
  $("*[data-selected-tag=#{selected_tag}]").remove()
  $("*[data-available-tag=#{selected_tag}]").removeClass('disabled')


$('.refresh_button').click ->
  $('#tags').submit()

$('#tags').submit ->
  return false if ($(@).serializeArray().length is 1)

$('.drop_down_button').click ->
  $('.available_tags').toggle()

$('.available_tag').click ->
  unless $(@).hasClass('disabled')
    add_tag_to_list $(@).text()
    $(@).addClass('disabled')


$('body').on 'click', '.remove_selected_tag', (e)->
  tag_being_removed = $(@).parent().data 'selected-tag'
  remove_tag_from_list(tag_being_removed);
  $(@).parent().remove();
tagger = File.open('mongo_data.js', 'w')

tagger.puts 'db.tagger.remove();'

reinstate_tags = ['hasTVBlocked', 'hasBroadbandBlocked', 'hasTalkBlocked', 'reinstatedSuccessfully']

new_bill_tags = ['hasDiscountsAsCR', 'hasDiscountsAsMinus', 'hasDiscountColumn', 'hasNoDiscountColumn','hasBiggerFontSize', 'hasNormalFontSize', 'hasFreeItemsGrouped']

product_additions_tags = ['addedTVProduct', 'addedBroadband', 'addedTalk']

product_removals_tags = ['removedTVProduct', 'removedBroadband', 'removedTalk']

other_tags = ['changedPaymentDueDate', 'firstBill', 'seen_beta']

tags = reinstate_tags + new_bill_tags + product_additions_tags + product_removals_tags + other_tags

9000.times do |count|
  tags_to_use = tags.sample((0..tags.size - 1).to_a.sample)
  called_call_centre = tags_to_use.size.even?
  mongo_line = "\"uuid\":\"#{"%08d" % (count + 1)}\""
  mongo_line += ",\"tags\":[" + tags_to_use.map { |tag| "\"#{tag}\"," }.join.gsub(/,$/, '') + "]"
  mongo_line += ",\"called_call_centre\":#{called_call_centre}"
  mongo_line += ",\"date_called\":\"#{format('%02d', (1..30).to_a.sample)}/06/2013\""
  tagger.puts "db.tagger.insert({#{mongo_line}});"
end

tagger.close()

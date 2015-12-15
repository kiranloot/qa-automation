Then(/^user should see pewdiepie stuff$/) do
  expect(page).to have_content('Here are five Loot Crate things I really love, bros')
end

Then(/^user should see boogie2988 stuff$/) do
  expect(page).to have_content('MY TOP 3 STUPIDLY AWESOME CRATES')
end
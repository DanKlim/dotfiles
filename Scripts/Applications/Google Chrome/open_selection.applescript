# Open a new tab with the selected text.
set myjs to "
var selection = window.getSelection().toString().trim();
if (selection) {
  // Turn into a Google search if not a link.
  var url = /^https?:\\/\\//.test(selection)
    ? selection
    : 'https://www.google.com/search?q=' + encodeURIComponent(selection);
  console.log('opening new tab', selection);
  window.open(url);
}
"

tell application "Google Chrome"
  tell active tab of front window
    execute javascript myjs
  end tell
end tell

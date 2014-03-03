json.name child.name
json.description child.description
json.link url_for child
json.array! child.children do |group|
  json.partial! 'children', child: group
end

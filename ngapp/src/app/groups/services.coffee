app = angular.module "consulted.groups.services", []

app.service "Groups", [
  "$http"
  "$q"
  (http, q) ->
    groups = http.get("/groups")

    getGroups: () ->
      results = q.defer()
      groups.then (response) ->
        results.resolve response.data
      , (err) ->
        results.reject err

      results.promise

    getFlatGroups: () ->
      ids = q.defer()
      groups.then (response) ->
        {data} = response
        collection = []
        collect = (group) ->
          if group.children?.length > 0
            collect(child) for child in group.children
          collection.push group if group.parent_id?
        collect group for group in data
        ids.resolve collection
      , (err) ->
        ids.reject err

      ids.promise


]

app = angular.module 'consulted.common', []

app.service 'GroupData', [
  '$http'
  '$q'
  GroupData = (http, q) ->
    groups = http.get('/groups.json')
    getGroups: () ->
      result = q.defer()
      groups.then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
    findGroup: (id) ->
      result = q.defer()
      groups.then (response) ->
        {data} = response
        find = (data, id) ->
          for group in data
            if group.id is id
              return group
            found = find group.children, id
            return found if found

        group = find data, id
        result.resolve find data, id

      result.promise
]

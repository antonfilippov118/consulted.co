app = angular.module "scheduler", ['ngTouch', "ui.bootstrap"]

app.constant 'MOBILE_DAY_HEADER_FORMAT', 'dddd Do'
app.constant 'SMALLEST_MINUTE_STEP', 5
app.constant 'DEFAULT_DURATION', 30

app.directive "calendar", ["$modal", "SMALLEST_MINUTE_STEP", "DEFAULT_DURATION", (modal, SMALLEST_MINUTE_STEP, DEFAULT_DURATION) ->
	restrict: "A"
	replace: yes
	scope:
		events: "="
		week: "="
	templateUrl: "foo_scheduler"
	link: (scope, element, attr) ->
		scope.readOnly = attr.readOnly?
		id = 1
		scope.count = 0
		#scope.$watch "events", (newEvents) ->
		#	console.log "updated events"
		#, yes
		scope.currentDay = 1
		scope.backward = (event) ->
			if scope.currentDay > 1
				scope.currentDay--
			event.preventDefault()
		scope.forward = (event) ->
			if scope.currentDay < 7
				scope.currentDay++
			event.preventDefault()

		scope.add = (event, index) ->
			if ("day" in event.target.className.split(" ")) and !scope.readOnly
				target = $ event.target
				start = SMALLEST_MINUTE_STEP * Math.round((event.pageY - target.offset().top) / target.height() * (60 * 24) / SMALLEST_MINUTE_STEP)
				end = start + DEFAULT_DURATION
				modalInstance = modal.open
					templateUrl: "foo_edit"
					controller: "EditController"
					resolve:
						startMinutes: () ->
							start
						endMinutes: () ->
							end
						mode: () ->
							"add"
				modalInstance.result.then (bounds) ->
					[start, end, recurrence] = bounds
					event =
						time: [start, end]
						data:
							id: "$$gen_id#{id++}"
					scope.events[index].push event
					scope.$emit "scheduler.add", event.data, [start, end], [index], recurrence
				, () ->
					console.log "dismissed"

		scope.$on "remove", (event, bounds, data) ->
			[dayIndex, eventIndex] = bounds
			scope.events[dayIndex].splice eventIndex, 1
			scope.$emit "scheduler.remove", data

		scope.$on "update", (event, bounds, data, time, recurrence) ->
			scope.$emit "scheduler.update", data, time, bounds, recurrence

]

app.filter "dayHeader", ['MOBILE_DAY_HEADER_FORMAT', (mobileDayHeader) ->
	(week, day) ->
		day = week.clone().isoWeekday(day).format(mobileDayHeader)
]

app.filter "zeroPad", [() ->
	(input) ->
		"0#{input}".slice -2
]

app.filter "minutesToTime", ["$filter", (filter) ->
	{floor} = Math
	zeroPad = filter "zeroPad"
	(input) ->
		minutes = parseInt input
		"#{zeroPad(floor minutes / 60)}:#{zeroPad(minutes % 60)}"
]

app.directive "event", ["$modal", (modal) ->
	restrict: "A"
	replace: yes
	scope:
		event: "="
		index: "="
		parentIndex: "="
		readOnly: "="
	templateUrl: "foo_event"
	link: (scope, element, attr) ->
		mpd = 24 * 60
		[scope.start, scope.end] = scope.event.time
		scope.setPosition = () ->
			element.css
				top: "#{scope.start / mpd * 100}%"
				height: "#{(scope.end - scope.start) / mpd * 100}%"

		scope.setPosition()

		scope.delete = (event) ->
			scope.$emit "remove", [scope.parentIndex, scope.index], scope.event.data
			event.preventDefault()

		scope.edit = (event) ->
			unless scope.readOnly
				modalInstance = modal.open
					templateUrl: "foo_edit"
					controller: "EditController"
					resolve:
						startMinutes: () ->
							scope.start
						endMinutes: () ->
							scope.end
						mode: () ->
							"edit"
				modalInstance.result.then (bounds) ->
					[scope.start, scope.end, recurrence] = bounds
					scope.setPosition()
					scope.$emit "update", [scope.parentIndex, scope.index], scope.event.data, [scope.start, scope.end], recurrence
				, () ->
					console.log "dismissed"
			event.preventDefault()
]

app.controller "EditController", [
	"$scope"
	"$modalInstance"
	"startMinutes"
	"endMinutes"
	"mode"
	"SMALLEST_MINUTE_STEP"
	(scope, modalInstance, startMinutes, endMinutes, mode, SMALLEST_MINUTE_STEP) ->
		scope.title = if mode is "edit" then "Edit availability" else "Create availability"
		scope.button = if mode is "edit" then "Edit" else "Create"
		scope.minuteStep = SMALLEST_MINUTE_STEP
		{floor, max, min, round} = Math

		scope.minutesToDate = (minutes) ->
			d = new Date()
			d.setMinutes minutes % 60
			d.setHours floor minutes / 60
			d

		scope.dateToMinutes = (date) ->
			date.getHours() * 60 + date.getMinutes()

		scope.closest = (number) ->
			SMALLEST_MINUTE_STEP * round(number / SMALLEST_MINUTE_STEP)

		scope.start = scope.minutesToDate startMinutes
		scope.end = scope.minutesToDate endMinutes
		scope.recurrence = 0

		scope.accept = (event, start, end, recurrence) ->
			[time1, time2] = [scope.closest(scope.dateToMinutes(start)), scope.closest(scope.dateToMinutes(end))]
			[start, end] = [min(time1, time2), max(time1, time2)]
			recurrence = parseInt recurrence
			recurrence = 52 if recurrence > 52
			recurrence = 0 if recurrence < 0
			end += 5 if start is end
			modalInstance.close [start, end, recurrence]
			event.preventDefault()
		scope.dismiss = (event) ->
			modalInstance.dismiss 'cancel'
			event.preventDefault()
]

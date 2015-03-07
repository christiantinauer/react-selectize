ReactSelect = require \../../src/react-select.ls
React = require \react
{a, div, h1, h2} = React.DOM
$ = require \jquery-browserify
{concat-map, filter, map} = require \prelude-ls

App = React.create-class {

    render: -> 
        div null,
            div {class-name: \title}, 'React Select'
            div {class-name: \description}, 'A flexible and beautiful Select input control for ReactJS with multiselect & autocomplete'
            a {class-name: \github-link, href: 'http://github.com/furqanZafar/react-select/tree/develop', target: \_blank}, 'View project on GitHub'
            h1 null, 'Examples:'
            h2 null, 'MULTISELECT:'
            React.create-element ReactSelect, {
                values: @.state.selected-countries
                options: @.state.countries
                on-change: @.handle-countries-change
                on-options-change: @.handle-options-change
                placeholder-text: 'Select countries'
                restore-on-backspace: false
                create: (input) -> {label: input, value: "_#{input}"}
                max-items: 2
                style: {z-index: 1}
            }
            React.create-element ReactSelect, {
                disabled: @.state.selected-countries.length == 0
                values: @.state.selected-cities
                options: @.state.cities
                on-change: @.handle-cities-change
                placeholder-text: 'Select cities'
                restore-on-backspace: false
                max-items: 2
                style: {margin-top: 20, z-index: 0}
            }
            div {class-name: \copy-right}, 'Copyright © Furqan Zafar 2014. MIT Licensed.'

    get-initial-state: ->        
        {selected-countries: [], countries: [], selected-cities: [], cities: []}

    component-will-mount: ->
        self = @
        $.getJSON 'http://restcountries.eu/rest/v1/all'
            ..done (countries) -> self.set-state do 
                countries: (self.state.countries or []) ++ (countries |> map ({name, alpha2Code}) -> {value: alpha2Code, label: name})
            ..fail -> console.log 'unable to fetch countries'

    handle-countries-change: (selected-countries) ->
        @.set-state {selected-countries}

        cities = selected-countries |> concat-map (country) -> 
            [1 to 3] |> map (index) -> 
                {label: "#{country}_#{index}", value: "#{country}_#{index}"}

        selected-cities = @.state.selected-cities
            |> filter (city) -> city in (cities |> map (.value))

        @.set-state {cities, selected-cities}

    handle-cities-change: (selected-cities) ->
        @.set-state {selected-cities}

    handle-options-change: (options) ->
        @.set-state {countries: options}

}

countries = [{value: \ae, label: \UAE}, {value: \us, label: \USA}]

React.render (React.create-element App, {countries}), document.body
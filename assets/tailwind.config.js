// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')
// const defaultTheme = require('tailwindcss/defaultTheme')


module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  darkMode: 'media',
  theme: {
    extend: {
      fontFamily: {
        'Karla': ['Karla'],
        'jura': ['Jura'],
        'kosugi': ['Kosugi'],
        'vt323': ['vt323'],
      }
    },
    colors: {
      'lightsalmon': '#ffa07a',
      'crimson': '#dc143c',
      'mediumblue': '#0000cd',
      'lavender': '#F6E8EA',
      'crayolapink': '#EF626C',
      'licorice': '#22181C',
      'jet': '#312F2F',
      'tiffanyblue': '#84DCCF',
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({addVariant}) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({addVariant}) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({addVariant}) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({addVariant}) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}

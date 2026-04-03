/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        './app/views/**/*.html.erb',         // ERB-шаблоны
        './app/helpers/**/*.rb',             // Ruby helper-файлы
        './app/assets/stylesheets/**/*.css', // CSS Tailwind
        './app/javascript/**/*.js'           // JS контроллеры Stimulus
    ],
    theme: {
        extend: {},
    },
    plugins: [],
}
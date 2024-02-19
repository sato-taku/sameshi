module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require('daisyui')],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#F5F5DC",        
          "secondary": "#F5F5DC",
          "accent": "#FFD700",
          "neutral": "#FFD700",
          "base-100": "#ffffff",
          "info": "#C3B091",
          "success": "#FFD700",
          "warning": "#FFD700",
          "error": "#FF6347",
        },
      },
    ],
  },
}

<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .Title ]]</title>
  <link rel="stylesheet" href="/css/vuetify.min.css">
  <script src="/js/fontawesome.min.js"></script>
  <script src="/js/solid.min.js"></script>
  <style type="text/css">
  body {
      font-family: Verdana,Arial;
  }
  </style>
</head>
<body>
<p>Header</p>
<b>MAIN PAGE</b>
<a href="/api/run" onclickx="return false;">Run</a>
<p>Footer</p>
<div id = "app">
    <v-app>
<v-row align="center" justify="space-around">
   <v-icon>home</v-icon>
    <v-icon>calendar</v-icon>
    <v-icon>info</v-icon>
    OK
    <v-icon>fa fa-lock</v-icon>

    <v-icon>fa fa-search</v-icon>

    <v-icon>fa fa-list</v-icon>

    <v-icon>fa fa-edit</v-icon>

    <v-icon>fa fa-tachometer-alt</v-icon>

    <v-icon>fa fa-circle-notch fa-spin</v-icon>
  </v-row>
</v-app>
<i class="fa fa-home"></i>
<i class="fa fa-search"></i>
<script src="/js/vue.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script>
new Vue({
    vuetify: new Vuetify({
  icons: {
    iconfont: 'faSvg',
  },
}),
    el: '#app',
//    data: pageData(),
})
</script>
</body>
</html>


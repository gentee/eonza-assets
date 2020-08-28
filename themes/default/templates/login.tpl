<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .App.Title ]]</title>
  <link rel="icon" href="/favicon.ico" type="image/x-icon"> 
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="/css/vuetify.min.css">
  <link rel="stylesheet" href="/css/fontawesome.min.css">
  <link rel="stylesheet" href="/css/eonza.css">
  <!--link href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" rel="stylesheet"-->
</head>
<body>
<div id = "app" >
         <v-app>
         <div  style="height: 100%; display: flex;justify-content: center;align-items: center;
              background-color: #ccc;">
       <div style="max-width: 600px;min-width: 350px;background-color: #fff;border: 1px solid #888;padding: 2rem 1rem;
         display:flex;justify-content: center;align-items:center;flex-direction: column;">
          
          <div style="display: flex;justify-content:center;align-items:center;margin-bottom: 2rem;">
          <img src="/images/logo-48.png" style="width: 48px;height:48px;">
          <div style="font-size: 2rem;color: #777;margin-left: 1rem;">[[.App.Title]]</div>
          </div>
          <v-text-field
            v-model="password"
            :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'"
            rulesx="[rules.required, rules.min]"
            :type="show1 ? 'text' : 'password'"
            label="Password"
            outlined style="width: 250px;"
            hint="" 
            @click:append="show1 = !show1"
          ></v-text-field>
           <v-btn color="primary" @click="login">%login%</v-btn>
           <a href="/" style="margin-top: 1.5rem;">Forgot Password?</a>
       </div>
       </div>
          </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script src="/js/axios.min.js"></script>

<script>

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    methods: {
      login() {
        axios
        .post('/api/login', {password: this.password})
        .then(response => { 
            console.log('response');
/*          if (!response.data.error) {
          } else {
            //this.errmsg(response.data.error);
          }*/
        });
      },
      reload() {
        this.checkChanged(()=> {
          axios
          .get('/api/reload')
          .then(response => (location.reload(true)));
        });
      },
    }
})

function appData() { 
    return {
        show1: false,
        password: '',
    }
}
</script>

</body>
</html>


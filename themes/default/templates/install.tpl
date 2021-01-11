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
       <div style="max-width: 600px;min-width: 350px;background-color: #fff;border: 1px solid #aaa;
         padding: 2rem 1rem;
         display:flex;justify-content: center;align-items:center;flex-direction: column;">
          
          <div style="display: flex;justify-content:center;align-items:center;margin-bottom: 1rem;">
          <img src="/images/logo-48.png" style="width: 48px;height:48px;">
          <div style="font-size: 2rem;color: #777;margin-left: 1rem;">[[.App.Title]]</div>
          </div>
          <div>{{res.sellang}}</div>
          <v-select v-model="lang" :items="langs">
          </v-select>
           <v-btn color="primary" @click="submit">{{res.continue}}</v-btn>
       </div>
       </div>
          </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script src="/js/axios.min.js"></script>

<script>

const resLang = {
    [[range $key, $list := .LangRes ]]
        [[$key]]: {
            [[range $ikey, $ival := $list ]]
                [[$ikey]]: '[[$ival]]',
            [[end]]
        },
    [[end]]
}

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    methods: {
        keyProcess(event) {
            if (event.keyCode == 13) {
                this.submit();
            }
        },
       submit() {
        this.error = false
        const formData = new FormData();
        formData.set('lang', this.lang)
        axios({
              method: 'post',
              url: '/api/install',
              data: formData
              })
        .then(response => { 
          if (!response.data.error) {
              window.removeEventListener('keydown', this.keyProcess);
              location.reload()
          } else {
            this.error = true
            console.log(response.data.error)
          }
        });
      },
    },
    watch: {
        lang(newval) {
            this.res = resLang[this.lang]
        }
    },
    mounted() {
      window.addEventListener('keydown', this.keyProcess);
    },
})

function appData() { 
    return {
        lang: [[.Lang]],
        langs: [ [[range $key, $native := .Langs ]]{text: '[[$native]]', value: '[[$key]]'},[[end]] ],
        error: false,
        res: resLang['[[.Lang]]'],
    }
}
</script>

</body>
</html>


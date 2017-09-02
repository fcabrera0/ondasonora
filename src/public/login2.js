app = new Vue({
    el: '#app',
    data: {
        redirect: null,
        email: null,
        password: null
    },
    methods: {
        login: function () {
            axios.post(
                '/login',
                {
                    email: this.email,
                    password: this.password
                }
            ).then((res) => {
                console.log(res.data)
                if (res.data.status === 0) window.location.href = this.redirect || '/'
                else UIkit.notification(res.data.msg)
            })
        }
    }
})
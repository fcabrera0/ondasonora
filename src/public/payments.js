var app = new Vue({
    el: '#app',
    data: {
        project_id: null,
        items: [],
        method: 'none'
    },
    computed: {
       total: function () {
           var sum = 0
           this.items.forEach(function(e) { sum += e.floor * e.quantity })
           return sum
       }
    },
    methods: {
        pay: function () {
            if (this.total <= 0 || this.method === 'none') return
            var pay = window.open('', '_blank')
            axios.post(
                `/pay/${this.project_id}`,
                {
                    items: this.items,
                    method: this.method,
                    amount: this.total
                }
            ).then((res) => {
                if (res.data.status === 0) {
                    location.href = "/dash"
                    pay.location.href = res.data.data.url
                }
                else {
                    UIkit.notification(res.data.msg);
                    pay.close()
                }
            })
        }
    }
})
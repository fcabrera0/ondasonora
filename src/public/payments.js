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
            $.post('/pay/' + this.project_id, {
                items: this.items,
                method: this.method,
                amount: this.total
            }, (res) => {
                console.log(res)
            })
        }
    }
})
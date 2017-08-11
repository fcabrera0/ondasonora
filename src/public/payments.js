var app = new Vue({
    el: '#app',
    data: {
        items: [],
        current: null,
        method: 'none'
    },
    computed: {
       total: function () {
           var sum = 0
           this.items.forEach(function(e) { sum += e.amount * e.quantity })
           return sum
       }
    },
    methods: {
        pay: function () {

        },
        add: function (e) {
            this.items.push(e)
        },
        remove: function (e) {
            var index = this.items.indexOf(e)
            this.items.splice(index, 1)
        }
    }
})
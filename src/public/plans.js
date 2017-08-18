var app = new Vue({
    el: '#app',
    data: {
        project_id: null,
        plans: [],
        doc: {
            name: '',
            descr: '',
            floor: 0
        }
    },
    methods: {
        add: function () {
            this.plans.push(this.doc)
            this.doc = {
                name: '',
                descr: '',
                floor: 0
            }
        },
        remove: function(i) {
            this.plans.splice(i, 1)
        },
        save: function () {
            axios.post(
                `/plans/${this.project_id}`,
                {
                    plans: this.plans
                }
            ).then((res) => {
                console.log(res.data)
                if (res.data.status === 0) UIkit.notification("Guardado con éxito");
                else UIkit.notification(res.data.msg);
            })
        }
    }
})
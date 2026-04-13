import { LightningElement, track} from 'lwc';

export default class ToDOApp extends LightningElement {
    @track tasks = [];
    newTask ='';
    taskId = 0;

    handleChange(event){
        this.newTask = event.target.value;
    }

    addTask() {
        if(this.newTask.trim() === '') return;

        const newTaskObj = {
            id : this.taskId++,
            name : this.newTask,
            completed : false,
            className : ''
        };

        this.tasks = [...this.tasks, newTaskObj];
        this.newTask = '';
    }

    deleteTask(event){
        const id = event.target.dataset.id;
        this.tasks = this.tasks.filter(task => task.id != id);
    }

    toggleTask(event){
        const id = event.target.dataset.id;

        this.tasks = this.tasks.map(task => {
            if(task.id == id){
                const updated = {...task};
                updated.completed = !updated.completed;
                updated.className = updated.completed ? 'completed' : '';
                return updated;
            }
            return task;
        })
    }

}
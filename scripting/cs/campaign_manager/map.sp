
enum struct Map{
    char name[MAPNAME_SIZE];

    void init(char name[MAPNAME_SIZE]){
        this.name = name;
    }

    char[] get_name(){
        return this.name;
    }
}

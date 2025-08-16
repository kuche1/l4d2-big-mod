
enum struct Map{
    char name[MAP_NAME_MAX_SIZE];

    // return `true` is the map is missing
    bool init(char name[MAP_NAME_MAX_SIZE]){
        char _fuzzyfind[1];
        if (!(FindMap(name, _fuzzyfind, sizeof(_fuzzyfind)) == FindMap_Found)){
            return true;
        }
        this.name = name;
        return false;
    }
}

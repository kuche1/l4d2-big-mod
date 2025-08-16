
// bool str_startswith(char[] str, char[] prefix){
//     return StrContains(str, prefix) == 0;
// }

bool str_is_whitespace(char[] str){
    int str_idx = 0;

    for(;;){
        char ch = str[str_idx];
        str_idx += 1;

        if(ch == 0){
            break;
        }

        if((ch == ' ') || (ch == '\t') || (ch == '\r')){ // IDK if checking for \r is necessary
            continue;
        }

        return false;
    }
    return true;
}

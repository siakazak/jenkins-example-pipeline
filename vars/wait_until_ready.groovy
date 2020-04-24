def call(String url) {
    while (get_http_rc(url) == 503 || get_http_rc(url) == 502) {
        sleep 1
    }
    sleep 20
}
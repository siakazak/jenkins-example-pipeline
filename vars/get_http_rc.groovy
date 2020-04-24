def call(String url) {
    def theurl = new URL(url);
    def http = (HttpURLConnection) theurl.openConnection();
    return (Integer) http.getResponseCode();
}

class Rectangle {
    private final int width;
    private final int height;
    Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
    int area() { return width * height; }
    int perimeter() { return 2 * (width + height); }
}

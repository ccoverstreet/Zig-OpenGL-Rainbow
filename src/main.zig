const std = @import("std"); 
const c = @import("c.zig"); 
const rand = std.rand;

fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.panic("Error: {}\n", .{@as([*:0]const u8, description)});
}

fn keyCallback(win: ?*c.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
    if (action != c.GLFW_PRESS) return; 

    switch (key) {
        c.GLFW_KEY_ESCAPE => c.glfwSetWindowShouldClose(win, c.GL_TRUE),
        else => {}
    }
}

var window: *c.GLFWwindow = undefined;

pub fn main() !void {
    std.debug.warn("OpenGL Triangle in Zig using GLUT\n", .{});

    // Error callback is helpful for determining OpenGL errors
    _ = c.glfwSetErrorCallback(errorCallback);

    // Initialize glfw instance
    if (c.glfwInit() == c.GL_FALSE) {
        std.debug.warn("Could not initialize GLFW\n", .{});
    }
    defer c.glfwTerminate();
    
    // Setting window hints
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 2);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GL_TRUE);
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, c.GL_TRUE);
c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GL_TRUE);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
   
    // Creating holding var for primary monitor size
    var screen_width: c_int = undefined;
    var screen_height: c_int = undefined;

    // Getting screen size
    c.glfwGetMonitorWorkarea(c.glfwGetPrimaryMonitor(), null, null, &screen_width, &screen_height);
        
    // Creating OpenGL window
    window = c.glfwCreateWindow(screen_width, screen_height, "Rainbow", c.glfwGetPrimaryMonitor(), null) orelse {
        std.debug.panic("Unable to Create Window\n", .{});
    };
    defer c.glfwDestroyWindow(window);

    // Setting context
    c.glfwMakeContextCurrent(window);

    _ = c.glfwSetKeyCallback(window, keyCallback);

    // Less aggressive swap interval
    c.glfwSwapInterval(1);

    // constants
    const pi: f32 = 3.1428;

    while (c.glfwWindowShouldClose(window) == c.GL_FALSE) {
        var time: f32 = 0.1 * @floatCast(f32, c.glfwGetTime());
        
        c.glClearColor(std.math.sin(time), std.math.sin(time + pi * 2/3), std.math.sin(time + pi * 4/3), 1);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glfwSwapBuffers(window);

        // Poll for events from system
        c.glfwPollEvents(); 
    }
}

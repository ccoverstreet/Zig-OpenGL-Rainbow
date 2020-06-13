const std = @import("std"); const c = @import("c.zig"); const rand = std.rand; fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.panic("Error: {}\n", .{@as([*:0]const u8, description)});
}

var window: *c.GLFWwindow = undefined;

pub fn main() !void {
    std.debug.warn("OpenGL Triangle in Zig using GLUT\n", .{});

    _ = c.glfwSetErrorCallback(errorCallback);
    if (c.glfwInit() == c.GL_FALSE) {
        std.debug.warn("Could not initialize GLFW\n", .{});
    }
    defer c.glfwTerminate();
    
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 2);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GL_TRUE);
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, c.GL_TRUE);
c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GL_TRUE);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
        
    window = c.glfwCreateWindow(600, 600, "Rainbow", null, null) orelse {
        std.debug.panic("Unable to Create Window\n", .{});
    };
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);

    c.glfwSwapInterval(1);

    // Setup random
    var r = rand.Xoroshiro128.init(1);
    std.debug.warn("{}\n", .{r.random.float(f32)});
    
    const pi: f32 = 3.1428;

    while (c.glfwWindowShouldClose(window) == c.GL_FALSE) {
        var time: f32 = 0.1 * @floatCast(f32, c.glfwGetTime());
        
        c.glClearColor(std.math.sin(time), std.math.sin(time + pi * 2/3), std.math.sin(time + pi * 4/3), 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glfwSwapBuffers(window);

        // Poll for events from system
        c.glfwPollEvents(); 
    }
}

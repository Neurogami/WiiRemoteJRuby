package com.neurogami;

/**
 *
 * @author logan
 */
public class ResourceLoader {
    public Object getResource(String path) {
        return this.getClass().getClassLoader().getResource(path);
    }
}

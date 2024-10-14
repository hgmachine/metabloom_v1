from app.controllers.application import Application


app = Application()


if __name__ == '__main__':

    import eventlet
    eventlet.wsgi.server(eventlet.listen(('0.0.0.0', 8080)), app.wsgi_app)

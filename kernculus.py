from ipykernel.kernelapp import IPKernelApp
from ipykernel.kernelbase import Kernel

class Kernculus(Kernel):
    implementation         = 'Lambda Calculus'
    implementation_version = '0.0'
    language               = 'lambda-calculus'
    language_version       = '0.0'
    banner                 = 'Lambda Calculus for Enscribe'
    language_info = {
        'name':           'Lambda Calculus',
        'mimetype':       'text/plain',
        'file_extension': '.lc',
    }

    def do_execute(self
        code:             str,
        silent:           bool,
        store_history:    bool,
        user_expressions: dict,
        allow_stdin:      bool,
    ):
        if not silent:
            stream_content = {
                'name': 'stdout',
                'text': code,
            }
            self.send_response(self.iopub_socket, 'stream', stream_content)
        return {
            'status':           'ok',
            'execution_count':  self.execution_count,
            'payload':          [],
            'user_expressions': {},
        }

if __name__ == '__main__':
    IPKernelApp.launch_instance(kernel_class=Kernculus)

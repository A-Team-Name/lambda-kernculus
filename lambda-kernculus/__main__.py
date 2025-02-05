# jupyter machinery
from ipykernel.kernelapp import IPKernelApp
from ipykernel.kernelbase import Kernel

# lambda calculus evaluator (written in hy)
import hy
from .lc import lc

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

    def do_shutdown(self, restart: bool): pass

    def do_execute(self,
        code:             str,
        silent:           bool,
        store_history:    bool,
        user_expressions: dict,
        allow_stdin:      bool,
    ):
        if not silent:
            try:
                out = lc(code)
                self.send_response(
                    self.iopub_socket,
                    'stream',
                    {
                        'name': 'stdout',
                        'text': out,
                    },
                )
                status = 'ok'
            except Exception as e:
                self.send_response(
                    self.iopub_socket,
                    'stream',
                    {
                        'name': 'stderr',
                        'text': "ERROR: " + str(e),
                    },
                )
                status = 'error'
        return {
            'status':           status,
            'execution_count':  self.execution_count,
            'payload':          [],
            'user_expressions': {},
        }

if __name__ == '__main__':
    IPKernelApp.launch_instance(kernel_class = Kernculus)

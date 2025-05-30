# jupyter machinery
from ipykernel.kernelapp import IPKernelApp
from ipykernel.kernelbase import Kernel

# lambda calculus evaluator (written in hy)
import hy
from .lc import lc

# extras
import traceback

class Kernculus(Kernel):
    """Kernculus is a Jupyter kernel for the Lambda Calculus.

    Inherits:
        Kernel: Jupyter kernel base class.

    Attributes:
        implementation (str): Name of the kernel implementation.
        implementation_version (str): Version of the kernel implementation.
        language (str): Language name.
        language_version (str): Language version.
        banner (str): Banner message for the kernel.
        language_info (dict): Information about the language used in the kernel.
    """
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
        """Executes the given code in the Lambda Calculus environment.

        Args:
            code (str): The code to be executed.
            silent (bool): If True, suppress output.
            store_history (bool): If True, store the code in history.
            user_expressions (dict): User-defined expressions to evaluate.
            allow_stdin (bool): If True, allow standard input.

        Returns:
            dict[str, Any]: A dictionary containing the execution status, execution count, payload, and user expressions.
        """
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

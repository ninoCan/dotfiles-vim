""""""""" PYTHON VIRTUALENV SUPPORT {{{
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(
        compile(
            open(activate_this, "rb").read(),
            activate_this, 'exec'),
            dict(__file__=activate_this)
    )
EOF
"}}}
